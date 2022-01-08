var gauge = null;

var opts = {
    angle: 0.0, // The span of the gauge arc
    lineWidth: 0.24, // The line thickness
    radiusScale: 0.5, // Relative radius
    pointer: {
        length: 0.39, // // Relative to gauge radius
        strokeWidth: 0.035, // The thickness
        color: '#000000' // Fill color
    },
    limitMax: false, // If false, max value increases automatically if value > maxValue
    limitMin: false, // If true, the min value of the gauge will be fixed
    colorStart: '#284DAA', // Colors
    colorStop: '#8FC0DA', // just experiment with them
    strokeColor: '#E0E0E0', // to see which ones work best for you
    generateGradient: true,
    highDpiSupport: true, // High resolution support
    // renderTicks is Optional
    renderTicks: {
        divisions: 5,
        divWidth: 1.1,
        divLength: 0.7,
        divColor: '#333333',
        subDivisions: 3,
        subLength: 0.5,
        subWidth: 0.6,
        subColor: '#666666'
    }
};

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
            if (event.data.enable) {
                var target = document.getElementById('nos-gauge-canvas'); // your canvas element
                gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
                gauge.maxValue = 100; // set max gauge value
                gauge.setMinValue(0); // Prefer setter over gauge.minValue = 0
                gauge.animationSpeed = 32; // set animation speed (32 is default value)
                gauge.set(0); // set actual value
            } else if (gauge) {
                delete gauge;
            }
        } else if (event.data.type == "setGaugeData") {
            console.log("setting gauge data! cur: " + event.data.current)
            if (gauge) {
                gauge.maxValue = event.data.max;
                gauge.set(event.data.current);
            }
        }
    });
});