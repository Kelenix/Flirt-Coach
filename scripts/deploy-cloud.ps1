# Déploie la base (migrations) et les Edge Functions sur le projet Supabase cloud
# indiqué dans config/prod.json. À lancer depuis la racine du projet :
#   & .\scripts\deploy-cloud.ps1
# Le mot de passe de la base est demandé par la CLI : il n'est jamais écrit dans un fichier.
$ErrorActionPreference = 'Stop'

function Assert-Step([string] $step) {
    if ($LASTEXITCODE -ne 0) { throw "Échec : $step" }
}

$config = Get-Content config/prod.json -Raw | ConvertFrom-Json
if ($config.SUPABASE_URL -notmatch '^https://([a-z0-9]{20})\.supabase\.co/?$') {
    throw 'SUPABASE_URL invalide dans config/prod.json'
}
$ref = $Matches[1]
Write-Host "Projet cible : $ref" -ForegroundColor Cyan

# 1. Le compte connecté doit voir le projet ; sinon, connexion au bon compte.
# Selon la version de la CLI, la liste est un tableau ou un objet { projects: [...] }.
$listed = supabase projects list -o json | ConvertFrom-Json
$projects = @($listed) + @($listed | ForEach-Object { $_.projects })
if (-not ($projects | Where-Object { $_.ref -eq $ref })) {
    Write-Host "Ce projet n'est pas visible avec le compte actuel : connecte-toi avec le compte qui le possède." -ForegroundColor Yellow
    supabase login
    Assert-Step 'connexion'
}

# 2. Lien local -> projet cloud (demande le mot de passe de la base).
supabase link --project-ref $ref
Assert-Step 'lien au projet'

# 3. Migrations : la liste s'affiche, puis la CLI demande confirmation.
supabase db push
Assert-Step 'migrations'

# 4. Edge Functions (regroupées côté serveur, sans Docker). Les réglages verify_jwt
#    de supabase/config.toml (webhook RevenueCat, rappel AdMob) sont appliqués.
supabase functions deploy --project-ref $ref --use-api
Assert-Step 'Edge Functions'

Write-Host ''
Write-Host 'Terminé. Secrets serveur présents :' -ForegroundColor Green
supabase secrets list --project-ref $ref
Write-Host 'Attendus : ANTHROPIC_API_KEY (IA) ; plus tard REVENUECAT_WEBHOOK_SECRET et REVENUECAT_SECRET_API_KEY (achats).'
