package neo4j

import akka.actor.{ActorSystem, Props}
import akka.stream.ActorMaterializer
import akka.stream.scaladsl._
import akka.kafka.scaladsl._
import akka.kafka.scaladsl.Consumer
import akka.kafka._
import akka.actor.ActorRef
import akka.pattern.ask
import akka.util.Timeout
import com.wingman.neo4j.Neo4jActor
import org.neo4j.driver.{AuthTokens, GraphDatabase}

import scala.concurrent.duration._
import slick.jdbc.PostgresProfile._

import scala.language.postfixOps

object ReplicatorStart {

  def main(args: Array[String]){
    // Create the Actor system
    val system = ActorSystem("Neo4jActorSystem")

    // Initialize the Neo4j driver // Since this is in a test case, we are hard coding it
    val driver = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j", "mysecretpassword"))

    // Create the actor
    val neo4jActor = system.actorOf(Props(new Neo4jActor(driver)), "neo4jActor")

    // Sample JSON string (your provided JSON)
    val jsonString = {
      """
    {
      "nodes": [
        {
          "label": "User",
          "properties": [
            { "name": "mtn", "type": "string", "unique": true, "value":"9729986610"}
          ],
          "primaryKey": "name"
        },
        {
          "label": "IP",
          "properties": [
            { "name": "value", "type": "string", "unique": true, "value":"143.21.22.345"}
          ],
          "primaryKey": "value"
        }
      ],
      "relationships": [
        {
          "type": "ACCESSED_FROM",
          "startNode": {"type":"User", "name":"mtn", "value":"9729986610"},
          "endNode": {"type":"IP", "name":"value", "value":"143.21.22.345"}
        }
      ]
    }
  """

      // Send the JSON to the Neo4j actor for processing
      /*"constraints": [
          { "type": "unique", "nodeLabel": "Person", "property": "name" },
          { "type": "unique", "nodeLabel": "Movie", "property": "title" }
        ]
        */
    }

    neo4jActor ! jsonString
  }
}
