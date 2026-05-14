async function start() {

    await initLanguage('en');

    initMap();
    initViewer();
    initOverlays();
    initHeroToggle();

    track('page_view');
}

function initHeroToggle() {
    const hero = document.getElementById('hero');
    const toggle = document.getElementById('heroToggle');

    toggle.onclick = () => {
        hero.classList.toggle('collapsed');
        toggle.textContent = hero.classList.contains('collapsed') ? '+' : '−';
    };
}

start();