function escapeHtml(unsafe) {
    return unsafe
        //.replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        //.replace(/"/g, "&quot;")
        //.replace(/'/g, "&#039;")
}

$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show()
        } else {
            $("#container").hide()
        }
    }
    display(false)
    window.addEventListener('message', (event) => {
        var item = event.data;
        if (item.type === "ui") {
            if (item.enable === true) {
                item.content = escapeHtml(item.content)
                $("#form").val(item.content)
                display(true)
                document.body.style.display = event.data.enable ? "block" : "none"
            } else {
                display(false)
                document.body.style.display = event.data.enable ? "none" : "block"
            }
        }

    });
    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://_notepad/exit', JSON.stringify({}))
        }
    };
    $("#submit").click(function () {
        let input = $("#form").val()
        if (input.length >= 2048) {
            $.post('http://_notepad/error', JSON.stringify({
                error: "Too many characters!",
            }))
            return
        }
        $.post('http://_notepad/save', JSON.stringify({
            main: input
        }))
        return
    });
});
