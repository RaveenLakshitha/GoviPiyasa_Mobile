
import "./style.css"
import image from './card.jpg';
import * as React from 'react';
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';

import Grid from '@mui/material/Grid';
import { styled } from '@mui/material/styles';
import Paper from '@mui/material/Paper';
import Avatar from '@mui/material/Avatar';
import { Link } from "react-router-dom";

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(1),
  textAlign: 'center',
  color: theme.palette.text.secondary,
}));

const bull = (
  <Box
    component="span"
    sx={{ display: 'inline-block', mx: '2px', transform: 'scale(0.8)' }}
  >
    •
  </Box>
);

export default function BoxCard(props) {
  return (
    <Link to="/shop">
    <Card sx={{ display: 'flex', height: '130px'}}>
      <Box sx={{ display: 'flex', flexDirection: 'row', paddingTop:"5%" , width:"50%"}}>
        <CardContent sx={{ flex: '1 0 auto' }}>
          <Typography component="div" variant="h6" color="green" fontWeight="bold" >
            {props.name}
          </Typography>
        </CardContent>
      
      </Box>
      <Avatar
  alt="Remy Sharp"
  src={props.image}
  sx={{ width: 100, height: 100 , marginRight:"5px" , marginTop:"5%"}}
/>
      {/* <CardMedia
        component="img"
        sx={{ width: 151 }}
        image={props.image}
        alt="Live from space album cover"
      /> */}


    </Card>
    </Link>
    // <Card sx={{ Width: 200 , Hight:100}}>
    //   <CardContent>

    //   {/* <Box sx={{ flexGrow: 1 }}>
    //     <Grid>
    //     <Grid xs={6} sx={{backgroundColor:'red'}}>
    //       <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
    //         {props.name}
    //       </Typography>

    //     </Grid>
    //     <Grid xs sx={{backgroundColor: 'green'}}>
    //       <img src={shop} className= "image1"/>
    //     </Grid>
    //     </Grid>
    //     </Box> */}
      
       
    //     {/* <Typography variant="h5" component="div">
    //       be{bull}nev{bull}o{bull}lent
    //     </Typography>
    //     <Typography sx={{ mb: 1.5 }} color="text.secondary">
    //       adjective
    //     </Typography> */}
    //     {/* <Typography variant="body2">
    //       well meaning and kindly.
    //       <br />
    //       {'"a benevolent smile"'}
    //     </Typography> */}
    //   // </CardContent>
    // //   <CardActions>
    // //     <Button size="small">Learn More</Button>
    // //   </CardActions>
    // // </Card>
  );

}
