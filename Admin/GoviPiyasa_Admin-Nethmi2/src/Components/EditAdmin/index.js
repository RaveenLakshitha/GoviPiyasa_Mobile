import { Modal } from "react-bootstrap";
import { Form, Button, Col, Row } from "react-bootstrap";
import axios from "axios";
import React, { useState } from "react";
import background from './background_2.png';

const EditAdmin = (props) => {
    const [contact, setContact] = useState("");
    const [name, setName] = useState("");
    const [city, setCity] = useState("");
    const user_token = window.localStorage.getItem("token");

    const handleSubmit = (e) => {
        e.preventDefault();
    
        axios
          .post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/UpdateLoggedUser", {
            contactNumber: contact,
            userName: name,
            city: city,
          })
          .then((res) => {
            console.log(res);
            console.log(res.data);
            alert("inserted");
          });
      };
      return (
        <div  style={{backgroundImage:`url(${background})`}}>
          <Modal show={props.show} onHide={props.handleClose} centered>
            <Modal.Header closeButton>
              <Modal.Title>Edit Profile</Modal.Title>
            </Modal.Header>
            <Modal.Body>
              <Form onSubmit={handleSubmit}>
                <Row>
                  <Col>
                    <Form.Group controlId="formName">
                      <Form.Label column="sm">Name</Form.Label>
                      <Form.Control
                        className="m-2 w-75"
                        type="text"
                        size="sm"
                        name="name"
                        placeholder="Enter name"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                      />
                    </Form.Group>
                  </Col>
    
                  <Col>
                    <Form.Group controlId="formName">
                      <Form.Label column="sm">City</Form.Label>
                      <Form.Control
                        className="m-2 w-75"
                        type="text"
                        size="sm"
                        name="name"
                        placeholder="Enter city"
                        value={city}
                        onChange={(e) => setCity(e.target.value)}
                      />
                    </Form.Group>
                  </Col>
                </Row>
    
                <Row>
                <Col>
                    <Form.Group controlId="formContactNo">
                      <Form.Label column="sm">Contact number</Form.Label>
                      <Form.Control
                        className="m-2 w-75"
                        type="text"
                        size="sm"
                        placeholder="Contact number"
                        value={contact}
                        onChange={(e) => setContact(e.target.value)}
                      />
                    </Form.Group>
                  </Col>
                 
                </Row>
    
                <Button
                  type="submit"
                  onClick={props.handleClose}
                  //  onClick={() => handleSubmit()}
                  className="m-3"
                  variant="success"
                >
                  Submit
                </Button>
              </Form>
            </Modal.Body>
            <Modal.Footer>
              <Button variant="secondary" onClick={props.handleClose}>
                Close
              </Button>
            </Modal.Footer>
          </Modal>
        </div>
      );
    };
    
    export default EditAdmin;
    