import { Link } from "react-router-dom";
import "./styles.css";
import { SidebarData } from "../SidebarData";
import MenuIcon from '@mui/icons-material/Menu';
import { IconButton } from "@mui/material";



const Sidebar = () => {
  
  return (
    <div className="sidebar">
      {"."}
      <IconButton> 
        <MenuIcon sx={{color:"white"}} fontSize="small"/>
      </IconButton>
      
      <ul className="sidebarlist">
        {SidebarData.map((val, key) => {
          return (
            <li
              key={key}
              /* onClick={(event) => {
                event.preventDefault();
                window.location.pathname = val.link;
              }} */
              className="row"
            >
              <Link to={val.link} className="link">
                <li className="sideBarList">
                  <div id="icon">{val.icon}</div>{" "}
                  <div id="title">{val.title}</div>
                </li>
              </Link>

              {/* <li className="sideBarListItem"><InventoryIcon className='sideBarIcon'/>Products</li> */}
            </li>
          );
        })}
      </ul>
    </div>
  );
};

export default Sidebar;
