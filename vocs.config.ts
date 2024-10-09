import { defineConfig } from 'vocs'
 
export default defineConfig({
  description: 'Build reliable apps & libraries with lightweight, \
    composable, and type-safe modules that interface with Ethereum.', 
  title: 'STARKLUDO',
  logoUrl:"/starkLudo logo.jpg",
  rootDir: './book/docs',
  sidebar: [
    { 
      text: 'Overview', 
      link: '/', 
    }, 
    { 
      text: 'Features', 
      link: '/features/features', 
    }, 
    { 
      text: 'Gameplay and Rules',
      collapsed: true,
      items: [ 
        { 
          text: 'Rolling Dice', 
          link: '/gameplayandrules/rollingdice', 
        },
        { 
          text: 'Safety Zones', 
          link: '/gameplayandrules/safetyzones', 
        },
        { 
          text: 'Rules', 
          link: '/gameplayandrules/rules', 
        },
      ],
    },
    { 
      text: 'Game Components',
      collapsed: true,
      items: [ 
        { 
          text: 'Account', 
          link: '/gamecomponents/account', 
        },
        { 
          text: 'Leaderboard', 
          link: '/gamecomponents/leaderboard', 
        },
        { 
          text: 'Multiplayer', 
          link: '/gamecomponents/multiplayer', 
        },
        { 
          text: 'Game Appearance', 
          link: '/gamecomponents/gameappearance', 
        },
      ],
    },
    { 
      text: 'Starknet wallet, NFT, and Tokenbound account Relationship in StarkLudo', 
      link: '/relationshipinstarkludo/relationshipinstarkludo', 
    }, 
  ],
  font: {
    google: "Poppins",
  },
  theme: {
    colorScheme: "dark",
    variables: {
      color: {
        textAccent: "#A7C9F8",
        background: "#0D1D3D",
        backgroundDark: "#041028",
      },
      content: {
        horizontalPadding: "40px",
      },
    },
  },
  socials: [
    {
      icon: "github",

      link: "https://github.com/sivicstudio/starkludo",
    },
    {
      icon: "x",
      link: "https://x.com/LudoOnStarknet",
    },
  ],

  topNav: [
    {
      text: "v1.0.0-alpha.4",
      items: [
        {
          text: "Releases",
          link: "https://github.com/sivicstudio/starkludo/releases",
        },
        {
          text: "Contributing",
          link: "https://github.com/sivicstudio/starkludo/blob/dev/CONTRIBUTING.md",
        },
      ],
    },
  ],
})