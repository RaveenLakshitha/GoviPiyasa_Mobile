import React from "react";
import background from "../../Images/bgImage1.png"
import '../About/styles.css'
export default function About() {

  return (
    <div style={{backgroundImage: `url(${background})`, height:"510px"}}>

    <div className="bgdiv">
      <div className="aboutTxt">
          <h2>Welcome to GOVI PIYASA</h2><br></br>
          <h4>Buy and sell all the agri items via GOVI PIYASA </h4>
          <h4>Shop more and save more</h4>
          <h4>Empower agriculture in Sri Lanka</h4>
      </div>
    </div>
    </div>
  );

}
