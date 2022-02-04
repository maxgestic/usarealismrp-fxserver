Coloris({
    format: 'rgb'
})

$(function() {
    /* To talk with LUA */
    window.addEventListener('message', function(event) {
        if (event.data.type == "toggle") {
            /* Display */
            let mainAppDiv = document.querySelector("main");
            if (mainAppDiv.style.display == "flex") {
                mainAppDiv.style.display = "none";
            } else {
                mainAppDiv.style.display = "flex";
            }
        }
    });
    
    /* Close Menu */
    document.onkeydown = function(data) {
        if (data.which == 27) { // Escape key
            close();
        }
    };

    function formSubmitHandler() {
        let textContent = $("input[name='content']").val();
        let scaleMultiplier = $("input[name='scaleMultiplier']").val();
        let font = $("input[name='font']").val();
        let perspectiveScale = 1; // $("input[name='perspectiveScale']").val();
        let radius = $("input[name='radius']").val();
        let outline = document.querySelector("input[name='outline']").checked;
        let color = $("input[name='color']").val();
        let verticalOffset = $("input[name='verticalOffset']").val();
        color = color.replace("rgb", "");
        color = color.replace("(", "");
        color = color.replace(")", "");
        color = color.split(",")
        for (let i = 0; i < color.length; i++) {
            color[i] = color[i].replace(" ", "");
        }

        if (textContent.length <= 0 || textContent.length > 55) {
            $("input[name='content']").effect("shake");
            return;
        }

        if (verticalOffset > 0.7 || verticalOffset < -0.7) {
            $("input[name='verticalOffset']").effect("shake");
            return;
        }

        if (scaleMultiplier > 1 || scaleMultiplier < 0.5) {
            $("input[name='scaleMultiplier']").effect("shake");
            return;
        }


        if (font > 5 || font < 0) {
            $("input[name='font']").effect("shake");
            return;
        }

        if (radius < 5 || radius > 30) {
            $("input[name='radius']").effect("shake");
            return;
        }

        $.post('http://usa_motiontext/submit', JSON.stringify({
            content: textContent,
            scaleMultiplier: scaleMultiplier,
            font: font,
            perspectiveScale: perspectiveScale,
            radius: radius,
            outline: outline,
            color: color,
            verticalOffset: verticalOffset
        }));
        close();
    }

    function close() {
        let mainAppDiv = document.querySelector("main");
        mainAppDiv.style.display = "none";
        $.post('http://usa_motiontext/close', JSON.stringify({}));
    }

    $("#submit").click(function(){
        formSubmitHandler();
    });

    $("#close").click(function(){
        close();
    });
});