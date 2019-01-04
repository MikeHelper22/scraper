# scraper

To run from BASH (from the directory where you want the output file and html file cache):

```
docker run -it -v $(pwd):/data denversocietyofcreation/scraper
```

To run from Windows:

```
docker run -it -v /c/Users/<username>/<path to folder>:/data denversocietyofcreation/scraper
```

To run for a single District:

```
docker run -it -v /c/Users/<username>/<path to folder>):/data denversocietyofcreation/scraper /bin/bash
# ./scraper.sh -d "District Name" | tee /data/<filename>.csv
```

To run for a single State:

```
docker run -it -v /c/Users/<username>/<path to folder>:/data denversocietyofcreation/scraper /bin/bash
# ./scraper.sh -s "State Name" | tee /data/<filename>.csv
```
