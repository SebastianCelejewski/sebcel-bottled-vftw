function initViewer() {
    document.getElementById('closeBtn').onclick = closeViewer;

    document.getElementById('viewer').onclick = (e) => {
        if (e.target.id === 'viewer') {
            closeViewer();
        }
    };
}

function openViewer(photo) {
    document.getElementById('viewerImg').src = '/assets/photos/1x1' + photo.image;
    document.getElementById('photoCountry').textContent = photo.country;
    document.getElementById('photoUser').textContent = photo.userName ? 'Shared by ' + photo.userName : '';
    document.getElementById('photoStory').textContent = photo.story || '';
    document.getElementById('viewer').classList.remove('hidden');

    track('photo_opened', {
        photoId: photo.image,
        country: photo.country,
        source: "marker_popup"
    });
}

function closeViewer() {
    document.getElementById('viewer').classList.add('hidden');
}