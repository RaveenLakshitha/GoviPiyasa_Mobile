import React from "react";
import { Outlet } from "react-router";
import "./styles.css";


export default function Layout() {
  return (
    <div className="LayoutMain">
      <Outlet />
    </div>
  );
}
