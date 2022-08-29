import { Outlet } from "react-router";
import Footer from "../../Components/Footer";
import Sidebar from "../../Components/Sidebar";
import NewSideBar from "../../Components/Sidebar/index1";

import "./styles.css";

export default function Home() {
  
  return (
    <div className="HomeMain">
      <NewSideBar/>
      {/* <Sidebar/> */}
      <Outlet />

    </div>
  );
}
