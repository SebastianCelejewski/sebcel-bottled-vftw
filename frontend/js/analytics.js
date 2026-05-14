function getDeviceInfo() {

    const coarsePointer = window.matchMedia('(pointer: coarse)').matches;

    return {
        deviceType: coarsePointer ? 'touch' : 'desktop',
        viewportWidth: window.innerWidth,
        viewportHeight: window.innerHeight,
        orientation: window.innerWidth > window.innerHeight ? 'landscape' : 'portrait',
        browserLanguage: navigator.language
    };
}

function track(eventName, payload = {}) {

    const finalPayload = {
            ...getDeviceInfo(),
            ...payload
        };

    fetch(window.APP_CONFIG.analyticsEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            event: eventName,
            timestamp: Date.now(),
            ...finalPayload
        })
    }).catch(() => {
        console.log('Analytics unavailable');
    });
}