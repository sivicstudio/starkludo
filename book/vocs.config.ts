import { defineConfig } from "vocs";

export default defineConfig({
  description: "Ludo game on Starknet",
  title: "StarkLudo",
  logoUrl: "/logo.jpg",
  rootDir: ".",
  sidebar: [
    {
      text: "Overview",
      link: "/",
    },
    {
      text: "Features",
      link: "/features/features",
    },
    {
      text: "Gameplay and Rules",
      collapsed: true,
      items: [
        {
          text: "Rolling Dice",
          link: "/gameplayandrules/rolling-dice",
        },
        {
          text: "Safety Zones",
          link: "/gameplayandrules/safety-zones",
        },
        {
          text: "Rules",
          link: "/gameplayandrules/rules",
        },
      ],
    },
    {
      text: "Game Components",
      collapsed: true,
      items: [
        {
          text: "Account",
          link: "/gamecomponents/account",
        },
        {
          text: "Leaderboard",
          link: "/gamecomponents/leader-board",
        },
        {
          text: "Multiplayer",
          link: "/gamecomponents/multi-player",
        },
        {
          text: "Game Appearance",
          link: "/gamecomponents/game-appearance",
        },
      ],
    },
    {
      text: "Starknet wallet, NFT, and Tokenbound account Relationship in StarkLudo",
      link: "/relationshipinstarkludo/relationship-in-starkludo",
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
    {
      icon:"telegram",
      link:" https://t.me/+hnjQooODZOA2M2Rk",
    },
  ],

  topNav: [
    {
      text: "v1.0.0",
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
});
