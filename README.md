# DevOps Demo

This repo include a small DevOps demo

## Flask App

A small Flask app that can be dockerize and deployed on any container environment

### App Routes

- `GET /health` - health check route return 200 on success
- `POST, GET /ping` - return pong on success

## Infrastructure

Terraform module that deploy infrastructure provisioned the flask app
Module documentation is at [terraform/README.md](./terraform/README.md)
