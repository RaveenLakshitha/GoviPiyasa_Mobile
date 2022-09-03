import * as React from 'react';
import { useState } from 'react';
import { styled, useTheme } from '@mui/material/styles';
import Box from '@mui/material/Box';
import Drawer from '@mui/material/Drawer';
import CssBaseline from '@mui/material/CssBaseline';
import MuiAppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import List from '@mui/material/List';
import Typography from '@mui/material/Typography';
import Divider from '@mui/material/Divider';
import IconButton from '@mui/material/IconButton';
import MenuIcon from '@mui/icons-material/Menu';
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import { SidebarData } from "../SidebarData";
import Header from "../Header";
import { Link } from "react-router-dom";
import barimage from "./barimage.jpg";
import sidebar from './sidebar.jpg';
import logo from "../logo.png";

const drawerWidth = 220;

const Main = styled('main', { shouldForwardProp: (prop) => prop !== 'open' })(
  ({ theme, open }) => ({
    flexGrow: 1,
    // backgroundImage:{sidebar},
    padding: theme.spacing(0),
    transition: theme.transitions.create('margin', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    marginLeft: `-${drawerWidth}px`,
    ...(open && {
      transition: theme.transitions.create('margin', {
        easing: theme.transitions.easing.easeOut,
        duration: theme.transitions.duration.enteringScreen,
      }),
      marginLeft: 0,
    }),
  }),
);

const AppBar = styled(MuiAppBar, {
  shouldForwardProp: (prop) => prop !== 'open',
})(({ theme, open }) => ({
  transition: theme.transitions.create(['margin', 'width'], {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.leavingScreen,
  }),
  ...(open && {
    width: `calc(100% - ${drawerWidth}px)`,
    marginLeft: `${drawerWidth}px`,
    transition: theme.transitions.create(['margin', 'width'], {
      easing: theme.transitions.easing.easeOut,
      duration: theme.transitions.duration.enteringScreen,
    }),
  }),
}));

const DrawerHeader = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  padding: theme.spacing(0, 0),
  // necessary for content to be below app bar
  ...theme.mixins.toolbar,
  justifyContent: 'flex-end',
}));



export default function NewSideBar() {
  const theme = useTheme();
  const [open, setOpen] = useState(true);

  const handleDrawerOpen = () => setOpen(true);
  const handleDrawerClose = () => setOpen(false);


  return (
    <Box sx={{ display: 'flex' }}>
      <CssBaseline />
        <AppBar position="fixed" open={open} sx= {{backgroundColor: 'white'}}>
        
          <Toolbar>
            <IconButton color="default" aria-label="open drawer" onClick={handleDrawerOpen}
              edge="start" sx={{ mr: 2, ...(open && { display: 'none' }) }}>
              <MenuIcon />
            </IconButton>
          <Header/>
          </Toolbar>
        </AppBar>
      <Drawer 
        sx={{ width: drawerWidth, flexShrink: 0 ,
            '& .MuiDrawer-paper': { width: drawerWidth, boxSizing: 'border-box', backgroundColor:'#135405'}}}
        variant="persistent"
        backgroundImage={sidebar}
        anchor="left"
        open={open}
        style={{backgroundImage: `url('sidebar.jpg')`}}
      >
        <DrawerHeader>
        
              <img src={logo} height="50" alt="" />
         
          <IconButton onClick={handleDrawerClose} color="default">
            {theme.direction === 'ltr' ? <ChevronLeftIcon /> : <ChevronRightIcon />}
          </IconButton>
        </DrawerHeader>

        <Divider />
        

        <ul className="sidebarlist">
        {SidebarData.map((val, key) => {
          return (
            <li key={key} className="row">
              <Link to={val.link} className="link">
                <li className="sideBarList">
                  <div id="icon">{val.icon}</div>{" "}
                  <div id="title">{val.title}</div>
                </li>
              </Link>
            </li>
          );
        })}
      </ul>

      </Drawer>
      <Main open={open}>
        <DrawerHeader />
      </Main>
    </Box>
  );
}
