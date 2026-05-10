function initOverlays() {
    document.querySelectorAll('[data-overlay]').forEach(button => {
        button.onclick = () => {
            const overlayId = button.dataset.overlay;
            track("overlay_opened", {overlay: overlayId});
            document.getElementById(overlayId).classList.remove('hidden');
        };
    });

    document.querySelectorAll('.closeOverlay').forEach(button => {
        button.onclick = () => {
            button.closest('.overlay').classList.add('hidden');
        };
    });

    document.querySelectorAll('.overlay').forEach(overlay => {
        overlay.onclick = (e) => {
            if (e.target === overlay) {
                overlay.classList.add('hidden');
            }
        };
    });
}