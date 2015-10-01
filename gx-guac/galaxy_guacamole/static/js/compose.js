function load_notebook(url){
    $( document ).ready(function() {
        test_ie_availability(url, function(){
            append_notebook(url)
        });
    });
}
