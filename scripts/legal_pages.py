"""Génère les pages web des textes légaux à partir des textes de l'app.

Source unique : assets/legal/*_<langue>.txt (format de l'app : `# ` titre, `## ` section,
`- ` puce, sinon paragraphe), une page par langue de l'app. L'éditeur et le contact viennent
de config/prod.json, comme dans l'app. Sortie : build/legal-pages/, publiée sur GitHub Pages
(branche gh-pages).

Usage : python scripts/legal_pages.py
"""
import html
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "build" / "legal-pages"
APP = "Flirt Coach Pro"
# Page -> (source, titre, langue). Les adresses françaises sont celles déclarées aux stores.
PAGES = {
    "confidentialite.html": ("assets/legal/privacy_fr.txt", "Politique de confidentialité", "fr"),
    "conditions.html": ("assets/legal/terms_fr.txt", "Conditions d'utilisation", "fr"),
    "privacy.html": ("assets/legal/privacy_en.txt", "Privacy Policy", "en"),
    "terms.html": ("assets/legal/terms_en.txt", "Terms of Use", "en"),
    "datenschutz.html": ("assets/legal/privacy_de.txt", "Datenschutzerklärung", "de"),
    "nutzungsbedingungen.html": ("assets/legal/terms_de.txt", "Nutzungsbedingungen", "de"),
    "privacidad.html": ("assets/legal/privacy_es.txt", "Política de privacidad", "es"),
    "terminos.html": ("assets/legal/terms_es.txt", "Términos de uso", "es"),
    "privacidade.html": ("assets/legal/privacy_pt.txt", "Política de Privacidade", "pt"),
    "termos.html": ("assets/legal/terms_pt.txt", "Termos de Uso", "pt"),
}
# Textes propres à chaque langue : mention de mise à jour et pied de page.
LANGUAGES = {
    "fr": {"updated": "Dernière mise à jour", "footer": "coach de drague et messages, réservé aux adultes."},
    "en": {"updated": "Last updated", "footer": "flirting and texting coach, for adults only."},
    "de": {"updated": "Zuletzt aktualisiert", "footer": "Coach für Flirts und Nachrichten, nur für Erwachsene."},
    "es": {"updated": "Última actualización", "footer": "coach de coqueteo y mensajes, solo para adultos."},
    "pt": {"updated": "Última atualização", "footer": "coach de flerte e mensagens, só para adultos."},
}

STYLE = """
:root { color-scheme: dark; }
* { box-sizing: border-box; }
body { margin: 0; background: #1A1033; color: #EDE6FA;
  font: 17px/1.65 system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif; }
header { background: #2A1D4A; border-bottom: 2px solid #FF4D79; }
header div, main, footer { max-width: 760px; margin: 0 auto; padding: 0 20px; }
header div { display: flex; flex-wrap: wrap; gap: 8px 24px; align-items: center; padding: 14px 20px; }
.brand { font-weight: 700; font-size: 20px; color: #FFFFFF; text-decoration: none; }
.brand span { color: #FF4D79; }
nav a { color: #FFD6E6; margin-right: 16px; }
nav a[aria-current] { color: #FF4D79; font-weight: 600; }
main { padding-top: 24px; padding-bottom: 32px; }
h1 { font-size: 30px; line-height: 1.25; color: #FFFFFF; margin: 8px 0 4px; }
h2 { font-size: 21px; color: #FFD6E6; margin: 32px 0 8px; }
.updated { color: #B9A8DA; margin-top: 0; }
ul { padding-left: 22px; }
li { margin: 6px 0; }
a { color: #FF7A9C; }
footer { color: #B9A8DA; font-size: 14px; padding-top: 16px; padding-bottom: 32px;
  border-top: 1px solid #3A2C5E; }
"""


def config() -> dict:
    data = json.loads((ROOT / "config" / "prod.json").read_text(encoding="utf-8"))
    missing = [k for k in ("LEGAL_PUBLISHER", "SUPPORT_EMAIL") if not data.get(k)]
    if missing:
        sys.exit("config/prod.json : à renseigner avant publication : " + ", ".join(missing))
    return data


def body(text: str, publisher: str, contact: str, language: str) -> str:
    mail = f'<a href="mailto:{html.escape(contact)}">{html.escape(contact)}</a>'
    out, bullets = [], []

    def inline(value: str) -> str:
        value = html.escape(value.strip())
        return value.replace("{{EDITEUR}}", html.escape(publisher)).replace("{{CONTACT}}", mail)

    def flush() -> None:
        if bullets:
            out.append("<ul>" + "".join(f"<li>{b}</li>" for b in bullets) + "</ul>")
            bullets.clear()

    for line in text.splitlines():
        if line.startswith("- "):
            bullets.append(inline(line[2:]))
            continue
        flush()
        if line.startswith("## "):
            out.append(f"<h2>{inline(line[3:])}</h2>")
        elif line.startswith("# "):
            out.append(f"<h1>{inline(line[2:])}</h1>")
        elif line.startswith(LANGUAGES[language]["updated"]):
            out.append(f'<p class="updated">{inline(line)}</p>')
        elif line.strip():
            out.append(f"<p>{inline(line)}</p>")
    flush()
    return "\n".join(out)


def page(title: str, content: str, current: str, language: str) -> str:
    links = "".join(
        f'<a href="{name}" hreflang="{lang}"{" aria-current=\"page\"" if name == current else ""}>'
        f"{label}</a>"
        for name, (_, label, lang) in PAGES.items()
    )
    return f"""<!doctype html>
<html lang="{language}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(title)} — {APP}</title>
<style>{STYLE}</style>
</head>
<body>
<header><div><a class="brand" href="./">Flirt Coach <span>Pro</span></a><nav>{links}</nav></div></header>
<main>
{content}
</main>
<footer>{APP} — {LANGUAGES[language]["footer"]}</footer>
</body>
</html>
"""


def main() -> None:
    data = config()
    OUT.mkdir(parents=True, exist_ok=True)
    for name, (source, title, language) in PAGES.items():
        text = (ROOT / source).read_text(encoding="utf-8")
        content = body(text, data["LEGAL_PUBLISHER"], data["SUPPORT_EMAIL"], language)
        (OUT / name).write_text(page(title, content, name, language), encoding="utf-8")
    items = "".join(
        f'<li><a href="{name}" hreflang="{lang}">{label}</a></li>'
        for name, (_, label, lang) in PAGES.items()
    )
    index = (
        f"<h1>{APP}</h1>\n<p>Textes légaux de l'application · Legal texts of the app · "
        f"Rechtstexte der App · Textos legales de la aplicación · Textos legais do app.</p>\n"
        f"<ul>{items}</ul>"
    )
    title = "Textes légaux · Legal texts · Rechtstexte · Textos legales · Textos legais"
    (OUT / "index.html").write_text(page(title, index, "", "fr"), encoding="utf-8")
    (OUT / ".nojekyll").write_text("", encoding="utf-8")
    print(f"{len(PAGES) + 1} pages écrites dans {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
