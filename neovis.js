<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neovis</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
    <h1>Neo4j Data Visualization</h1>
    <div id="viz" style="width: 100%; height: 600px;"></div>
    <script src="https://unpkg.com/neovis.js@2.0.2"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const config = {
                containerId: "viz",
                neo4j: {
                    serverUrl: "bolt://localhost:7687",
                    serverUser: "neo4j",
                    serverPassword: "Samad@123"
                },
                labels: {
                    User: {
                        caption: "mtn"
                    },
                    IP: {
                        caption: "value"
                    }
                },
                relationships: {
                    ACCESSED_FROM: {
                        caption: true,
                        thickness: "count"
                    }
                },
                initialCypher: "MATCH (n)-[r]->(m) RETURN n, r, m"
            };

            const viz = new NeoVis.default(config);
            viz.render();
        });
    </script>
</body>

</html>