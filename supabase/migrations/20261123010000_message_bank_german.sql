-- Banque de messages en allemand (ADR-035) : 40 messages, mêmes catégories et même charte
-- que le français et l'anglais (ADR-034).

insert into public.message_bank (language, category, sort_order, body) values
  -- Einstieg: eine persönliche Aufhänger-Frage statt eines einfachen „Hi“.
  ('de', 'opener', 1, 'Ich muss dir eine wichtige Frage stellen: lieber Filmabend oder Spaziergang im Sonnenuntergang?'),
  ('de', 'opener', 2, 'Dein Profil hat mich zum Lächeln gebracht, und das passiert nicht oft. Was hat dich heute zum Lächeln gebracht?'),
  ('de', 'opener', 3, 'Ich habe gesehen, dass du gern reist. Wohin würdest du morgen ohne zu zögern zurückfliegen?'),
  ('de', 'opener', 4, 'Hi! Wir scheinen einen ähnlichen Geschmack zu haben. Was ist deine beste Musikentdeckung der letzten Wochen?'),
  ('de', 'opener', 5, 'Ich bin nicht besonders gut in ersten Nachrichten, also mache ich es einfach: Ich würde dich gern kennenlernen.'),
  ('de', 'opener', 6, 'Ernste Frage: Ananas auf Pizza, Verbrechen oder Genie? Von deiner Antwort hängt viel ab 😄'),
  ('de', 'opener', 7, 'Dein Wanderfoto hat mir Lust auf ein Abenteuer gemacht. Wo war das?'),
  ('de', 'opener', 8, 'Wenn du nur für dieses Wochenende eine Superkraft hättest, welche wäre es?'),
  -- Nachhaken: wieder Kontakt aufnehmen, ohne Vorwurf und ohne Druck.
  ('de', 'follow_up', 1, 'Hey! Ich musste an unser Gespräch neulich denken. Wie war deine Woche?'),
  ('de', 'follow_up', 2, 'Ich habe gerade etwas gesehen, das mich an dich erinnert hat 😄 Wie geht''s dir?'),
  ('de', 'follow_up', 3, 'Ich wollte mich nur kurz melden, ganz ohne Druck. Ich hoffe, bei dir läuft alles gut.'),
  ('de', 'follow_up', 4, 'Und, wie lautet dein Urteil über die Serie, von der du mir erzählt hast? Ich will wissen, ob ich anfangen soll!'),
  ('de', 'follow_up', 5, 'Wir haben mitten in einer Diskussion aufgehört, und ich bin mir immer noch nicht sicher. Und du?'),
  ('de', 'follow_up', 6, 'Klingt, als hättest du eine volle Woche gehabt. Halt durch, ich freue mich, von dir zu hören!'),
  ('de', 'follow_up', 7, 'Ich starte unser Gespräch neu mit einer leichten Frage: Was war dein schönster Moment diese Woche?'),
  ('de', 'follow_up', 8, 'Hallo! Ich wollte unser Gespräch nicht einschlafen lassen, ich habe mich wirklich gern mit dir unterhalten.'),
  -- Date: einfach vorschlagen und die Tür offen lassen.
  ('de', 'date', 1, 'Ich mag unsere Gespräche sehr. Hast du Lust, sie diese Woche bei einem Drink fortzusetzen?'),
  ('de', 'date', 2, 'Ich kenne ein kleines Café mit der besten heißen Schokolade der Stadt. Lust, das mit mir zu überprüfen?'),
  ('de', 'date', 3, 'Wir reden seit Tagen über Spaziergänge … wie wäre es, wenn wir am Wochenende einen zusammen machen?'),
  ('de', 'date', 4, 'Ich würde dich gern mal persönlich sehen. Hast du Donnerstag- oder Freitagabend Zeit?'),
  ('de', 'date', 5, 'Ein einfacher Vorschlag: ein Drink, eine Stunde, und wir schauen, ob wir uns auch in echt so gut verstehen. Lust?'),
  ('de', 'date', 6, 'Gerade läuft eine Ausstellung, die richtig gut aussieht. Wollen wir zusammen hingehen?'),
  ('de', 'date', 7, 'Ich bin neugierig, ob du in echt genauso witzig bist wie beim Schreiben. Gehen wir einen Kaffee trinken?'),
  ('de', 'date', 8, 'Kein Druck, falls es gerade nicht passt, aber ich würde dich wirklich gern treffen.'),
  -- Entschuldigung: aufrichtig, ohne sich übermäßig zu rechtfertigen.
  ('de', 'apology', 1, 'Es tut mir leid wegen vorhin. Das war nicht fair von mir, und ich verstehe, dass es dich verletzt hat.'),
  ('de', 'apology', 2, 'Ich schulde dir eine Entschuldigung: Ich habe lange nicht geantwortet, und so wollte ich nicht rüberkommen.'),
  ('de', 'apology', 3, 'Ich habe über das nachgedacht, was du gesagt hast, und du hast recht. Es tut mir leid.'),
  ('de', 'apology', 4, 'Tut mir leid, dass ich so kurzfristig abgesagt habe. Ich würde das gern wiedergutmachen, wenn du einverstanden bist.'),
  ('de', 'apology', 5, 'Meine Nachricht war ungeschickt, das tut mir leid. So habe ich es nicht gemeint.'),
  ('de', 'apology', 6, 'Ich suche keine Ausrede: Ich lag falsch und bereue es aufrichtig.'),
  ('de', 'apology', 7, 'Ich verstehe, wenn du etwas Zeit brauchst. Ich wollte dir nur sagen, dass es mir wirklich leidtut.'),
  ('de', 'apology', 8, 'Ich hätte nicht so reagieren sollen. Danke, dass du mir gesagt hast, wie es dir damit ging.'),
  -- Sanftes Ende: klar, respektvoll, ohne falsche Hoffnungen.
  ('de', 'soft_breakup', 1, 'Ich hatte schöne Momente mit dir, aber ich fühle nicht genug, um weiterzugehen. Ich möchte lieber ehrlich zu dir sein.'),
  ('de', 'soft_breakup', 2, 'Ich will ehrlich sein: Ich glaube nicht, dass wir zueinander passen. Ich wünsche dir wirklich alles Gute.'),
  ('de', 'soft_breakup', 3, 'Danke für unsere Gespräche. Ich möchte lieber nicht weitermachen und wollte es dir direkt sagen.'),
  ('de', 'soft_breakup', 4, 'Du bist ein toller Mensch, aber ich bin gerade nicht bereit für eine Beziehung.'),
  ('de', 'soft_breakup', 5, 'Ich sage es dir lieber, statt einfach zu verschwinden: Ich möchte dich nicht wiedersehen. Pass auf dich auf.'),
  ('de', 'soft_breakup', 6, 'Ich habe viel nachgedacht und glaube, es ist besser, wenn wir es dabei belassen. Danke für alles.'),
  ('de', 'soft_breakup', 7, 'Das fällt mir nicht leicht zu schreiben, aber ich sehe keine Zukunft für uns. Ich wollte dich nicht im Ungewissen lassen.'),
  ('de', 'soft_breakup', 8, 'Ich behalte unsere gemeinsame Zeit in guter Erinnerung, aber ich möchte hier aufhören. Ich hoffe, du findest, was du suchst.');
