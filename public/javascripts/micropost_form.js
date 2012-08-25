function new_post_validate() {
    var content = $("#micropost_content").val();
    if(!content || !jQuery.trim(content)) {
        $.pnotify({ text: "can not be null" });
        return;
    }
    if(content.length > 140) {
        $.pnotify({ text: "can not be more than 140 characters" });
        return;
    }
    $('form').submit();
}