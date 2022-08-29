import { useState } from "react";
import { Form, Button, Col, Row } from "react-bootstrap";
import { Modal } from "react-bootstrap";
import axios from "axios";
import "../../App.css";
import AlertMsg from "../../Components/Alert";


const InfoCategoryForm = (props) => {

  const user_token = window.localStorage.getItem("token");

  const [name, setName] = useState(" ");
  const [image, setImage] = useState(null);
  const [type, setType] = useState("Main");

  const [open, setOpen] = useState(false);
  const handleCloseAlert = () => setOpen(false);

  
  const addCategory = async () => {
    try{
      await axios.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/infoCategories/", 
        { categoryName : name, 
          image : image,
          categoryType : type
        },
        { headers : 
          {'Authorization' : `Bearer ${user_token}`}
        }
      ).then(() => {
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

      <Form className="formstyle">
        <Row>
          <Col>
          <Form.Group controlId="formFName">
            <Form.Label column="sm">Category name</Form.Label>
            <Form.Control className="m-2 w-75" type="text" size="sm" placeholder="Enter here..." 
              value={name} onChange={(e) => setName(e.target.value)}/>
          </Form.Group>
          </Col>
        </Row>
        <Row>
          <Col>
          <Form.Group controlId="formImage">
            <Form.Label column="sm">Category image</Form.Label>
            <Form.Control className="m-2 w-75" type="file" size="sm" placeholder="Upload here..."
             value={image} onChange={(e) => setImage(e.target.value)} />
          </Form.Group>
          </Col>
        </Row>
      
        
        <Button size="sm" className="m-3" variant="success" onClick={addCategory}>Submit</Button>
        
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
 
export default InfoCategoryForm;