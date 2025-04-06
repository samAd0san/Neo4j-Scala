# Integrate Neo4j with Scala

### 1. Create/Run the Neo4j Docker Image on Docker Desktop/Instance
```bash
docker run \
    --name neo4j-4.4 \
    -p 7474:7474 -p 7687:7687 \
    -e NEO4J_AUTH=neo4j/password \
    -e NEO4JLABS_PLUGINS='["apoc"]' \
    -e NEO4J_dbms_security_procedures_unrestricted=apoc.\\* \
    neo4j:4.4.23
```
or
```bash
docker run --name=neo4j -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/password neo4j:latest
```

### 2. Add Dependencies
build.sbt
```scala
// Neo4j Dependencies
lazy val commonDependencies = Seq(
  "org.neo4j.driver" % "neo4j-java-driver" % "4.4.10",
)
```

### 3. Configure
application.conf
```scala
neo4j {
  uri = "bolt://localhost:7687"
  user = "neo4j"
  password = "neo4j" # run neo4j docker image
  connection {
      timeout = 5s # Connection timeout
      encryption = false # Disable for local testing
  }
}
```

### 4. Test Neo4j Connection
Main.scala
```scala
import org.neo4j.driver.{AuthTokens, Driver, GraphDatabase}

// Testing Neo4j Connection
  val testNeo4jConnection = () => {
    Try {
      val uri = config.getString("neo4j.uri")
      val user = config.getString("neo4j.user")
      val password = config.getString("neo4j.password")

      val driver: Driver = GraphDatabase.driver(uri, AuthTokens.basic(user, password))
      val session = driver.session()
      val result = session.run("RETURN 'Hello, Neo4j!' AS message")
      val message = result.single().get("message").asString()

      println(s"Neo4j connection: $message")

      session.close()
      driver.close()
    } match {
      case Success(_) => println("Neo4j connection successful.")
      case Failure(exception) =>
        println(s"Neo4j connection failed: ${exception.getMessage}")
    }
  }

  def main(args: Array[String]): Unit = {
    println("Hello World!")

    // Neo4j Connection
    testNeo4jConnection()
  }
```
