# The-API-Awakens

A short time ago, in a Galaxy not so far away, you were taught about API’s. Now is your chance to harness the force (of newfound knowledge) and put the Star Wars API (SWAPI) to use in an iOS app.  

Using what you have learned about API’s, Networking, Concurrency and JSON you will GET information about three types of Star Wars entities: people, vehicles and starships. Each entity type will have it’s own view from a user perspective, though they can certainly be based on common code and/or storyboards. See below for links to mock-ups for the app. It is worth noting that the API is paginated and you are only required to retrieve and display the first page of results for a given API request. Retrieving and displaying all pages for a result is required for a rating of "exceeds expectations".  

You will notice that regardless of which view a user navigates to, there is a bar across the bottom showcasing the largest and smallest member of the group. In addition, because all measurements are given in metric units, you will need to create a feature that converts to British units, with a button tap. For starships and vehicles, students will need to create a button that can convert “Galactic Credits” to US Dollars, based on a exchange rate provided by the user in a text field.  

Lastly, be sure to include appropriate error handling. Please demonstrate the ability to predict and handle errors, including but not limited to:  

- The device being offline when an API call is made
- A user entering a 0 or negative exchange rate
- An error resulting from a key or element missing from the JSON
