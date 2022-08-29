import React from "react";
import { Modal } from "react-bootstrap";
import "./styles.css";
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Typography from '@mui/material/Typography';

const Preview = (props) => {

  return ( 
    <div>
      <Modal size="sm" show={props.show} onHide={props.handleClose}>
        <Modal.Header closeButton />
        <Card sx={{ maxWidth: 120, ':hover': { boxShadow: 6} }} className="cards" hoverable>
          <CardMedia
            component="img" height="80"
            image="https://doa.gov.lk/wp-content/uploads/2020/06/Banana-1.jpg"
          />
          <CardContent>
            <Typography gutterBottom variant="h6" fontSize={"medium"} component="div" textAlign={"center"}>
                Banana
            </Typography>
          </CardContent>
        </Card>
      </Modal>
    </div>
  );
}
 
export default Preview;