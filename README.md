# scraper

To run from BASH (from the directory where you want the output file and html file cache):

```docker run -it -v $(pwd):/data denversocietyofcreation/scraper```

To run from Windows:

```docker run -it -v "<folder name>":/data denversocietyofcreation/scraper```

To run for a single District:

```docker run -it -v $(pwd):/data denversocietyofcreation/scraper /bin/bash
# ./scraper.sh -d "District Name"```

To run for a single State:
```docker run -it -v $(pwd):/data denversocietyofcreation/scraper /bin/bash
# ./scraper.sh -s "State Name"```
