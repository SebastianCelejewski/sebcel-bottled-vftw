track('page_view');
async function start() {

    await initLanguage('en');

    initMap();
    initViewer();
    initOverlays();

    track('page_view');

    initHeroToggle();
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