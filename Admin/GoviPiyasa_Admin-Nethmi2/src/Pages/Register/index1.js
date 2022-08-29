import Container from "@mui/material/Container";
import Box from "@mui/material/Box";

import React, { useState } from "react";

import "./styles.css";
import axios from "axios";

export default function Registerss() {
  //const [cookies] = useCookies(["cookie-name"]);
  const [password, setPassword] = useState("");
  const [email, setEmail] = useState("");

  const handleSubmit = async (event) => {
    event.preventDefault();
    console.log("Ok");
    axios
      .post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/register", {
        password: password,
        email: email,
      })
      .then((res) => {
        console.log(res);
        console.log(res.data);
        localStorage.setItem("myData", res.data.token);
        alert("inserted");
      });
  };
  return (
    <div className="container">
      <React.Fragment>
        <Container sx={{ maxWidth: "sm", m: "auto", p: "2rem" }}>
          <Box
            sx={{ m: "auto", width: 500, eight: 500, color: "text.secondary", border: 1, p: "3rem", }}
          >
            <div className="container">
              <h2>Register Admin</h2>
              <form onSubmit={(e) => handleSubmit(e)}>
                <div>
                  <label htmlFor="email">Email</label>
                  <input
                    type="email"
                    name="email"
                    value={email}
                    placeholder="Email"
                    onChange={(e) => setEmail(e.target.value)}
                  />
                </div>
                <div>
                  <label htmlFor="password">Password</label>
                  <input
                    type="password"
                    placeholder="Password"
                    name="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
                <button type="submit">Submit</button>
              </form>
            </div>
          </Box>
        </Container>
      </React.Fragment>
    </div>
  );
}
