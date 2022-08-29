import axios from "axios";
import React, { useState } from "react";
import { Navigate } from "react-router";


export default function Signup() {

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [LoginPass, setLoginPass] = useState(false);


  const userLogin = async (event) => {
    event.preventDefault();

    try {
      const data = await axios.post( "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/login", { email, password } );
      console.log(data.data.token);
      window.localStorage.setItem("user_token", data.data.token);
      console.log(window.localStorage.getItem("user_token"));
      setLoginPass(true);
    } catch (e) {
      console.log(e);
    }
  };


  if (LoginPass) {
    return <Navigate to="/Home" />;
  }


  return (
    <div>
      <form onSubmit={userLogin}>

        <input value={email} type="text" placeholder="Email"
          onChange={(e) => setEmail(e.target.value)}
        />

        <input value={password} type="password" placeholder="Password"
          onChange={(e) => setPassword(e.target.value)}
        />

        <input type="submit" value="Login"></input>
        
      </form>
    </div>
  );
}
