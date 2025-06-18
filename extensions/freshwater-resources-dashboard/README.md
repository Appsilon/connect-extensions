## Freshwater Resources Dashboard - Availability and Trends

### Description:

The [Freshwater Resources Dashboard](https://connect.appsilon.com/fresh-water-resources/) offers a comprehensive view of freshwater availability across countries, using data from the AQUASTAT Statistics database. This dynamic dashboard utilizes an interactive map and trendline charts to deliver valuable insights into water resource distribution and changes over time.

Discover each country's per capita freshwater resources on the interactive map, color-coded according to availability levels. By hovering over a country, you can quickly access freshwater resources per capita and percentage of people with access to safe drinking water for each country.  

The trendline chart allows users to explore changes in per capita and percentage of people with access to safe drinking water over a selected time period for different countries, making it easy to identify fluctuations and patterns in water availability. Comparing multiple countries at once provides important context on regional and global scales.

Data for the dashboard is reliably sourced from the AQUASTAT Statistics database, which is managed by the Food and Agriculture Organization (FAO) of the United Nations. AQUASTAT gathers, analyzes, and shares information on water resources, water usage, and agricultural water management for over 180 countries.

This powerful resource empowers policymakers, researchers, and stakeholders to better comprehend the global state of freshwater resources and pinpoint areas requiring improved water management strategies, ultimately contributing to a more sustainable future.

### Dashboard Features:

- Interactive map with freshwater resources per capita and percentage of people with access to safe drinking water for each country
- Trendline charts for freshwater resources and percentage of people with access to safe drinking water over time
- Comparison of multiple countries simultaneously
- Filter countries by region for focused analysis on trendlines
- App has interactive draggable elements to select either of the indicators on map
- Onclick to a country allows users to pin a country for reference with another country

### Future Additions:

- Additional indicators, such as freshwater withdrawals by sector
- Country rankings based on water availability, stress, and management efficiency
- Downloadable data and visualizations in various formats
- Additional data layers and integration with external data sources
- Geolocation feature to display user's location on the map and corresponding country insights

<details>
<summary> Links </summary>
<br/>
 
- Demo Video: https://www.loom.com/share/252da0749515420481e1b6fecba4d3d6
- Deployed App: https://connect.appsilon.com/fresh-water-resources/
- Git Board: https://github.com/orgs/Appsilon/projects/84/views/1
- GitHub Repo: https://github.com/Appsilon/app_sprint_renewflow
 
</details>

### App Structure
<details>
<summary> This app is built with [Rhino](https://github.com/Appsilon/rhino), a framework for building Shiny apps. It is structured as follows:  </summary>
<br/>
 
```
.
├── app
│   ├── js
│   │   └── index.js
│   ├── logic
│   │   |── __init__.R
|   |   |── read_data.R
|   |   └── trend_chart.R
│   ├── static
│   │   |── favicon.ico
│   |   |── img
│   |   |   |── appsilon-logo.png
│   |   |   |── d4g_light.png
│   |   |   └── rhino.png
│   |   |── css
│   |   |   └── app.min.css
│   |   └──js
|   |       └── app.min.js
│   ├── data
│   │   |── all_variables_dataset.qs
│   │   |── complete_data.qs
│   │   |── continent_mapping.qs
│   │   |── data_map.qs
│   │   |── data_processing.R
│   │   |── data_trendline.qs
│   │   |── map_data.dbf
│   │   |── map_data.prj
│   │   |── map_data.shp
│   │   └── map_data.shx
│   ├── html
│   │   └── tooltip.html
│   ├── json
│   │   └── appsilon.echarts.json
│   ├── styles
│   │   |── main.scss
│   │   |── _about_section.scss
│   │   |── _country_selection.scss
│   │   |── _leaflet_section.scss
│   │   └── _navbar_section.scss
│   ├── view
│   │   |── __init__.R
│   |   |── about_section.R
│   |   |── line_chart.R
│   |   |── map.R
│   |   └── navbar_section.R
│   └── main.R
├── tests
│   ├── cypress
│   │   └── integration
│   │       └── app.spec.js
│   ├── testthat
│   │   └── test-main.R
│   └── cypress.json
├── app.R
├── RhinoApplication.Rproj
├── dependencies.R
├── renv.lock
└── rhino.yml
``` 
---
</details>


### Prerequisites

This is an application built in [Shiny](https://shiny.rstudio.com/) which is included in the Rhino framework.
To run it, make sure you have R >= 4.0.0 (Recommended R 4.2.2) installed. [RStudio](https://rstudio.com/products/rstudio/download/)
For JavaScript and Sass development you'll also need
[Node.js](https://nodejs.org/en/download/) (>= 16.0.0).

### Dependencies
Run `renv::restore(clean = TRUE)` to synchronize the project library with the lockfile
when you initially clone the repo or switch branches.

### Data
Application-ready data is included in `app/data`.
However, if you want to generate this data from raw sources, run `source("./scripts/generate_data.R")`

### Development

This project uses [renv](https://rstudio.github.io/renv/) to manage R package dependencies.
To add/remove packages, edit the `dependencies.R` file and run the following commands:
```r
renv::install() # Install added packages
renv::snapshot() # Update the lockfile
renv::restore(clean = TRUE) # Uninstall removed packages
```

### Running
To run the app, use `Rscript -e 'shiny::runApp(launch.browser = TRUE)'`.

### Deployment
You can use the RStudio GUI to deploy the app to RStudio Connect or shinyapps.io.
You only need to include the following files:
`.Rprofile`, `dependencies.R`, `app.R`, and `app/` directory.

### Testing
This project uses [testthat](https://testthat.r-lib.org/) for unit testing and [Cypress](https://www.cypress.io/) for integration testing.
To run the tests, run `npm run test` or `npm run test:watch` to run the tests in watch mode.

#### Contributing
- We welcome contributions to this project! To get started, please read our Contributing Guide, which provides guidelines and best practices for submitting your ideas, reporting issues, and submitting pull requests.

<details>
 <summary> <b> DoD (Definition of Done): </b>  </summary>
<br/>
 
- Major project work has a corresponding task. If there’s no task for what you are doing, create it. - Each task needs to be well defined and described.
- Change has been tested (manually or with automated tests), everything runs correctly and works as expected. No existing functionality is broken.
- No new error or warning messages are introduced.
- All interaction with a semantic functions, examples and docs are written from the perspective of the person using or receiving it. They are understandable and helpful to this person.
- If the change affects code or repo sctructure, README, documentation and code comments should be - updated.
- All code has been peer-reviewed before merging into any main branch.
- All changes have been merged into the main branch,  for development we use(dev).
- Continuous integration checks (linter, unit tests) are configured and passed.
- Unit tests added for all new or changed logic.
- All task requirements satisfied. The reviewer is responsible to verify each aspect of the task.
- Any added or touched code follows our style-guide.
---
</details>

<details>
 <summary> <b>  PULL REQUEST TEMPLATE </b>  </summary>
<br/>
 

```

### Changes proposed in this pull request:
 - 

### How to test the change:
 - 

Closes #


### Author Verification

- [ ] Ensure a well-defined and described task exists for the change; create one if necessary.
- [ ] Open a pull request for the change and assign a reviewer.

### Reviewer Verification

- [ ] Test the change (manually or with automated tests) to ensure it runs correctly and doesn't break existing functionality.
- [ ] Verify no new error or warning messages are introduced.
- [ ] Confirm user interactions, messages, plots, and reports are clear, helpful, and written with the end-user in mind.
- [ ] Update README, documentation, and code comments to reflect the change.
- [ ] Review all code before merging.
- [ ] Merge changes into the `dev` branch for ongoing development.
- [ ] Configure and ensure continuous integration checks (linter, unit tests, integration tests) pass.
- [ ] Add unit tests for all new or changed logic.
- [ ] Create end-to-end frontend and integration tests.
- [ ] Include all data assumptions in the code (e.g., as assertions).
- [ ] Verify all task requirements are satisfied.
- [ ] Ensure changes follow the Appsilon style-guide.
- [ ] Confirm results are easily reproducible (assuming data remains consistent).
- [ ] Document and make accessible all data sources to the reviewer (if applicable).

```
---
</details>

### Support
If you encounter any issues or have questions about this project, please create a new issue in our GitHub repository. Our team will do our best to assist you.

### Acknowledgements
We would like to thank the Food and Agriculture Organization (FAO) of the United Nations for providing the AQUASTAT Statistics database, which serves as the foundation for this project. We also appreciate the contributions of our community members, whose feedback and support have helped improve this resource.

## Appsilon

<img src="https://avatars0.githubusercontent.com/u/6096772" align="right" alt="" width="6%" />

Appsilon is a **Posit (formerly RStudio) Full Service Certified Partner**.<br/>
Learn more at [appsilon.com](https://appsilon.com).

Get in touch [opensource@appsilon.com](mailto:opensource@appsilon.com)

Check the [Rhinoverse](https://rhinoverse.dev).

<a href = "https://appsilon.com/careers/" target="_blank"><img src="https://raw.githubusercontent.com/Appsilon/website-cdn/gh-pages/WeAreHiring1.png" alt="We are hiring!"/></a>

