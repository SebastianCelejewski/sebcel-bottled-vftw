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
    if (photo.city) {
        document.getElementById('photoLocation').textContent = photo.city + ', ' + photo.country;
    } else {
        document.getElementById('photoLocation').textContent = photo.country;
    }
    
    document.getElementById('photoUser').textContent = photo.userName ? 'Shared by ' + photo.userName : '';
    
    if (photo.description) {
        document.getElementById('photoDescription').textContent = photo.description || '';
        document.getElementById('photoDescription').style.display = 'block';
    } else {
        document.getElementById('photoDescription').style.display = 'none';
    }

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