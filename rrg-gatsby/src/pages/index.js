import React from 'react'
import Link from 'gatsby-link'

const IndexPage = () => (
  <div style={{ color: 'grey' }}>
    <h1>Hi people</h1>
    <Link to="/page-2/">Go to page 2</Link>
  </div>
)

export default ({data }) => {
  console.log(data);
  return (
    <div>
      <h2 style={{display:"inline-block"}}>
      Helping renters in San Jose, California understand the laws and programs in place to protect them.
      </h2>
      <br/>
      <h2 style={{display:"inline-block"}}>
      I need help with
      </h2>
      {data.allMarkdownRemark.edges.map(({ node }) => (
        <div className="container">
          <div key={node.id}>
            <h3 style={{marginBotton: `1.5rem`}}>
              {node.frontmatter.title}{" "}
            </h3>
            <p>{node.excerpt}</p>
          </div>
        </div>
      ))}

    </div>
  );
};

export const query = graphql`
  query IndexQuery {
    allMarkdownRemark {
      totalCount
      edges {
        node {
          id
          frontmatter {
            title
            date(formatString: "DD MMMM, YYYY")
          }
          excerpt
        }
      }
    }
  }
`;
