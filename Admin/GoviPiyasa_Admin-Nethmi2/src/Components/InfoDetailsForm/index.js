import { Form, Button, Col, Row } from "react-bootstrap";
import { Modal } from "react-bootstrap";
import { useState } from "react";
import { useParams } from 'react-router-dom';
import axios from "axios";
import "../../App.css";
import AlertMsg from "../../Components/Alert";



const InfoDetailsForm = (props) => {

  const user_token = window.localStorage.getItem("token");
  let params = useParams();
  console.log("parent"+params.id);

  const [title, setTitle] = useState(" ");
  const [desc, setDesc] = useState("");

  const [open, setOpen] = useState(false);
  const handleCloseAlert = () => setOpen(false);



  const addInfo = async () => {
    try{
      await axios.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/articles/"+props.id, 
        { 
          Title : title, 
          Description : desc
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

      <Form>
        <Row>
          <Col>
          <Form.Group controlId="forminfotitle">
            <Form.Label column="sm">Title</Form.Label>
            <Form.Control className="m-2 w-75" type="text" size="sm" placeholder="Enter title" 
             value={title} onChange={(e) => setTitle(e.target.value)}/>
          </Form.Group>
          </Col>
          {/* <Col>
          <Form.Group controlId="formDistrict">
              <Form.Label column="sm">Category</Form.Label>
              <Form.Select className="m-2 w-75" size="sm" defaultValue="Choose...">
                <option>Choose...</option>
                <option>...</option>
              </Form.Select>
            </Form.Group>
          </Col> */}
        </Row>

        <Row>
          <Form.Group controlId="forminfodes">
            <Form.Label column="sm">Description</Form.Label>
            <Form.Control className="m-2 w-75" size="sm" as="textarea" rows={3} placeholder="Enter description" 
            value={desc} onChange={(e) => setDesc(e.target.value)}/>
          </Form.Group>
        </Row>

      {/* 
        <Row>
        <Form.Group controlId="forminfodesc">
          <Form.Label column="sm">Description</Form.Label>
          <Form.Control className="m-2 w-75" size="sm" as="textarea" rows={3} placeholder="Enter description" />
        </Form.Group>
          
        </Row> */}
      
        <Button size="sm" className="m-3" variant="success" onClick={addInfo}> Submit </Button>
        
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
 
export default InfoDetailsForm;