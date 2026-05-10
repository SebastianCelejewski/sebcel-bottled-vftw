let translations = {};

async function initLanguage(lang) {
    const response = await fetch(`lang/${lang}.json`);
    translations = await response.json();

    document.getElementById('heroTitle').textContent = translations.title;
    document.getElementById('subtitle').textContent = translations.subtitle;
    document.getElementById('instructionText').textContent = translations.instruction;

    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.dataset.i18n;

        if (translations[key]) {
            el.textContent = translations[key];
        }
    });

    document.querySelectorAll('.langBtn').forEach(btn => {
        btn.classList.remove('active');

        if (btn.dataset.lang === lang) {
            btn.classList.add('active');
        }

        btn.onclick = () => initLanguage(btn.dataset.lang);
    });
}