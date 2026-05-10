function track(eventName, payload = {}) {
    return;
    
    fetch('/analytics', {
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