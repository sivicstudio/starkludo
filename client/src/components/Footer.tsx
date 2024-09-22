import { useEffect } from "react";
import dojoengine from "../assets/images/dojoengine.png";
import starknet from "../assets/images/starknet.png";
import dice1 from "../assets/images/dice-2.svg";
import dice2 from "../assets/images/dice-3.svg";
import "../styles/Footer.scss";

const Footer = () => {
  useEffect(() => {
    const updateFooterPosition = () => {
      const body = document.body;
      const html = document.documentElement;
      const footer = document.querySelector(".footer") as HTMLElement;

      const documentHeight = Math.max(
        body.scrollHeight,
        body.offsetHeight,
        html.clientHeight,
        html.scrollHeight,
        html.offsetHeight
      );
      const viewportHeight = window.innerHeight;

      if (documentHeight <= viewportHeight) {
        footer.style.position = "absolute";
        footer.style.bottom = "0";
      } else {
        footer.style.position = "relative";
      }
    };

    updateFooterPosition();
    window.addEventListener("resize", updateFooterPosition);

    return () => {
      window.removeEventListener("resize", updateFooterPosition);
    };
  }, []);

  return (
    <footer className="footer">
      <div className="footer__content">
        <p>
          Powered by
          <img
            src={starknet}
            alt="Starknet logo"
            className="footer__logo footer__logo__starknet"
          />
          and
          <img
            src={dojoengine}
            alt="Dojo Engine logo"
            className="footer__logo"
          />
        </p>
      </div>
      <img src={dice1} alt="Dice 1" className="dice dice-1" />
      <img src={dice2} alt="Dice 2" className="dice dice-2" />
    </footer>
  );
};

export default Footer;
