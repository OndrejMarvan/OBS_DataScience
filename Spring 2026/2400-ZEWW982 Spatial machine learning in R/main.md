### **Welcome to Spatial Machine Learning in R!**

by prof [Katarzyna Kopczewska](https://usosweb.wne.uw.edu.pl/kontroler.php?_action=katalog2/osoby/pokazOsobe&os_id=23298), dr [Maria Kubara](https://usosweb.wne.uw.edu.pl/kontroler.php?_action=katalog2/osoby/pokazOsobe&os_id=321240), mgr [Monika Kot](https://usosweb.wne.uw.edu.pl/kontroler.php?_action=katalog2/osoby/pokazOsobe&os_id=401232), dr [Kateryna Zabarina](https://usosweb.wne.uw.edu.pl/kontroler.php?_action=katalog2/osoby/pokazOsobe&os_id=285417)

##### Rules of passing:

1) Final analytical paper in RPubs (prepared by 1 or 2 people) using the methods presented in class - 50%

2) Review of an article available in the world literature - article selected by the student and approved by the course coordinator - 30%

3) Online post-tests - 15%

4) Activity in class - 5%

##### Schedule:

|Class|Date|Topic|Lecturer|
|---|---|---|---|
|1|2/18/2026|Working with spatial data 1 (R classes, reading, visualisation)|dr Kubara|
|2|2/25/2026|Working with spatial data 2 (integration of different types of spatial data)|mgr Kot|
|3|3/4/2026|Working with spatial data 3 (spatial weight matrices, radial zoning, knn)|mgr Kot|
|4|3/11/2026|Working with spatial data 4 (DEGURBA)|mgr Kot|
|5|3/18/2026|Supervised ML|prof Kopczewska|
|6|3/25/2026|Supervised ML (rf, ann, spatial and radial weight matrices)|prof Kopczewska|
|7|4/1/2026|Supervised ML (geographically weighted random forest)|prof Kopczewska|
|8|4/15/2026|Supervised ML (convolutional neural networks)|dr Kubara|
|9|4/22/2026|Supervised ML in space (causality-based ML models)|dr Kubara|
|10|4/29/2026|Unsupervised ML (clustering of geolocated points)|prof Kopczewska|
|11|5/6/2026|Unsupervised ML (measuring spatial agglomeration)|prof Kopczewska|
|12|5/13/2026|Unsupervised ML in space (surface modelling methods)|mgr Kot|
|13|5/20/2026|Unsupervised ML in space (comparison of spatial distributions)|mgr Kot|
|14|5/27/2026|Unsupervised ML in space (spatial association rules)|prof Kopczewska|
|15|6/3/2026|Kriging as a method for extrapolating the results of ML from points to surfaces|dr Zabarina|

Note: Topics may be adjusted during the semester. The list is a guide.

## Class 01
sf
geopandas for Python but still limited functions 
Nested geometry

Buffer? 

# 02
Function Purpose 
st_transform(x, crs)`Reproject to new CRS`
st_filter(x, y, .predicate)`Keep features of x matching y`st_join(x, y, join)`Spatial join (adds y's columns to x)`st_intersects()`Predicate: any shared space`st_within()`Predicate: strictly inside`st_intersection(x, y)`Geometry clip (returns overlapping pieces)`st_centroid(x)`Compute centroids`st_distance(x, y)`Pairwise distances`st_bbox(x)`Bounding box`st_coordinates(x)`Extract coordinates as matrix`st_drop_geometry()`Remove geometry (for tabular operations)`st_make_valid(x)`Fix invalid geometries`st_area(x)`Compute area`rast(...)`Create raster template (terra)`rasterize(xy, rast, values, fun)`Convert points to raster
