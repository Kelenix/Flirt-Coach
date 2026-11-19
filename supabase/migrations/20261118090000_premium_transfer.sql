-- Restauration sur une nouvelle installation (ADR-027). Une réinstallation crée un nouveau
-- compte anonyme ; « Restaurer mes achats » y rattache l'abonnement et RevenueCat envoie un
-- événement TRANSFER (anciens identifiants → nouveaux). Le droit Premium suit l'abonnement :
-- il est déplacé, en une seule transaction, du plus récent des anciens comptes vers les
-- nouveaux. Renvoie false s'il n'y a aucun abonnement actif à déplacer.

create function public.transfer_premium(p_from uuid[], p_to uuid[])
returns boolean
language plpgsql security definer set search_path = '' as $$
declare
  v_source public.entitlements%rowtype;
  v_target uuid;
begin
  select * into v_source
    from public.entitlements
   where user_id = any(p_from)
     and not user_id = any(p_to)
     and is_premium
     and (expires_at is null or expires_at > now())
   order by expires_at desc nulls first
   limit 1;
  if not found then
    return false;
  end if;

  -- set_premium n'écrase pas un droit plus récent déjà présent sur le nouveau compte.
  foreach v_target in array p_to loop
    perform public.set_premium(v_target, true, v_source.product_id, v_source.expires_at);
  end loop;

  update public.entitlements
     set is_premium = false, updated_at = now()
   where user_id = any(p_from)
     and not user_id = any(p_to);
  return true;
end;
$$;

revoke execute on function public.transfer_premium(uuid[], uuid[]) from public, anon, authenticated;
grant execute on function public.transfer_premium(uuid[], uuid[]) to service_role;
