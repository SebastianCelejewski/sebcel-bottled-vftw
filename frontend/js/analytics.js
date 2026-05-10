function track(eventName, payload = {}) {
    fetch(window.APP_CONFIG.analyticsEndpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            event: eventName,
            timestamp: Date.now(),
            ...payload
        })
    }).catch(() => {
        console.log('Analytics unavailable');
    });
}