function new_post_validate() {
    var content = $("#micropost_content").val();
    if(!content || !jQuery.trim(content)) {
        alert("The micropost's content cannot be null");
        return;
    }
    if(content.length > 140) {
        alert("The content cannot have more than 140 characters!");
        return;
    }
    $('form').submit();
}