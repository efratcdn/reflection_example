  This file is created automatically, by the cover_edges utility
<'
extend transfer{
    keep soft address == select {
        50 : edges;
        50 : others;
    };
};
extend transfer{
    keep soft first_data == select {
        50 : edges;
        50 : others;
    };
};
'>
