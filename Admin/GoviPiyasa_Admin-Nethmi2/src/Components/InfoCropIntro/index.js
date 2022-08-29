import { Form, Button, Col, Row } from "react-bootstrap";
import { Modal } from "react-bootstrap";
import { useState } from "react";
import { useParams } from 'react-router-dom';
import axios from "axios";
import "../../App.css";
import AlertMsg from "../../Components/Alert";



const InfoCropIntro = (props) => {

  const user_token = window.localStorage.getItem("token");
  let params = useParams();
  console.log("parent"+params.id);

  const [title, setTitle] = useState("Not set");
  const [family, setFamily] = useState("Not set");
  const [sciName, setSciName] = useState("Not set");
  const [desc, setDesc] = useState("Not set");

  const [open, setOpen] = useState(false);
  const handleCloseAlert = () => setOpen(false);



  const addIntro = async () => {
    try{
      await axios.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/information", 
        { 
          Title : title, 
          Family : family,
          ScientificName : sciName,
          Description : desc,
          categoryId : params.id
        },
        { headers : 
          {'Authorization' : `Bearer ${user_token}`}
        }
      ).then(()=>{
        props.handleClose();
        setOpen(true);
      })
      
    }catch{

    }
  }

  return (
    <div>

      <Modal show={props.show} onHide={props.handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>{props.title}</Modal.Title>
        </Modal.Header>
        <Modal.Body>

      <Form className="me-2">
        <Row>
          {/* <Col>
          <Form.Group controlId="formFName">
            <Form.Label column="sm">Crop name</Form.Label>
            <Form.Control className="m-2 w-100" type="text" size="sm" placeholder="Enter here..." 
             value={name} onChange={(e) => setName(e.target.value)}/>
          </Form.Group>
          </Col> */}
          <Col>
          <Form.Group controlId="formSName">
            <Form.Label column="sm">Scientific name</Form.Label>
            <Form.Control className="m-2 w-75" type="text" size="sm" placeholder="Enter here..." 
             value={sciName} onChange={(e) => setSciName(e.target.value)}/>
          </Form.Group>
          </Col>
        </Row>

        <Row>
          <Col>
          <Form.Group controlId="formFmName">
            <Form.Label column="sm">Family name</Form.Label>
            <Form.Control className="m-2 w-75" type="text" size="sm" placeholder="Enter here..." 
             value={family} onChange={(e) => setFamily(e.target.value)}/>
          </Form.Group>
          </Col>
        </Row>

        <Row>
          <Col>
          <Form.Group controlId="formDesc">
            <Form.Label column="sm">Description</Form.Label>
            <Form.Control className="m-2 w-100" type="text" as="textarea" rows={3} size="sm" placeholder="Enter here..." 
             value={desc} onChange={(e) => setDesc(e.target.value)}/>
          </Form.Group>
          </Col>
        </Row>

        {/* <Row>
          <Form.Group controlId="formImage">
            <Form.Label column="sm">Upload an image</Form.Label>
            <Form.Control className="m-2 w-75" size="sm" type="file" placeholder="Enter title" 
             value={image} onChange={(e) => setImage(e.target.value)}/>
          </Form.Group>
        </Row> */}

      
        <Button size="sm" className="m-2" variant="success" onClick={addIntro}> Submit </Button>
        
      </Form>
      </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={props.handleClose}>Close</Button>
        </Modal.Footer>
      </Modal>

      <AlertMsg open={open} msg="Successfully added" handleClose={handleCloseAlert}/>

    </div>

  );
}
 
export default InfoCropIntro;