import { gql } from "@apollo/client";

export const ALL_GAME_IDS_QUERY = gql`
  query {
    starkludoGameModels {
      edges {
        node {
          id
        }
      }
    }
  }
`;
