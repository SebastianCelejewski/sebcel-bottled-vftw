mapboxgl.accessToken = window.APP_CONFIG.mapboxAccessToken;

let map;

function initMap() {

    map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/sebastian-celejewski/cmob3hz37000301s7f1423hvx',
        projection: 'globe',
        zoom: 1.8,
        center: [70, 25]
    });

    const mq = window.matchMedia('(pointer: coarse)');

    function updateDots() {
        const pointSize = Math.max(6, Math.min(18, window.innerWidth / 40));
        map.setPaintProperty('Dots', 'circle-radius', pointSize);
    }

    mq.addEventListener('change', updateDots);

    map.on('load', () => {

        map.on('click', 'Dots', (e) => {

            const properties = e.features[0].properties;

            openViewer({
                id: properties.PhotoId,
                country: properties.Country,
                city: properties.City,
                image: properties.ImageKey,
                userName: properties.Username,
                description: properties.Description
            });
        });

        updateDots();
    });
}