'use client';
import { useEffect } from 'react';
import NeoVis from 'neovis.js';

export default function NeoGraph() {
  useEffect(() => {
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

    const viz = new NeoVis(config);
    viz.render();
  }, []);


  return (
    <div>
        <style jsx>{`
            .headstyle {
                text-align: center;
                font-size: 2em;
                margin-top: 20px;
            }
            #viz {
                margin: 0 auto;
                width: 100%;
                height: 600px;
            }
        `}</style>
        
        <h1 className='headstyle'>Neo4j Data Visualization</h1>
      <div id="viz" style={{ width: '100%', height: '600px' }}></div>
    </div>
  );
}
