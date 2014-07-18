Spacechat
=========

Chatroom API server for app agnostic chat services. 
User creates a 'space', and invites their friends via an invite code to the space. Friends join space and post pictures, text. A good time is had by all.

#### Technology
The server is built with the Ruby Programming Language. The following libraires are employed:

- Sinatra
- ActiveRecord

#### Installation

This assumes Ruby and the 'bundler' gem are installed

1. ``` bundle install ```
2. ``` rackup ```

The server will now be listening on your local machine and ready to receive requests.

#### Routes and Inputs

#### get "/"
Returns the index page and message. The purpose of this is to ensure the server is up and running on this address. HTTP Basic auth is not required.


#### get "/user/:user_id/spaces"
Returns an array of the spaces which the specified user id is a member.


#### get "/user/:user_id/space/:space_id"
Returns an array of all the messages within a specified space. The user must be a member of the space.

#### post "/user/:user_id/space/:space_id"
Post a message to the space specified by :space_id. The user must be a member of the space. Messages are JSON structures of the form:

Request Body

```
{ text: string , 
picture_url:  string,
content_id: integer,
content_image_url: string,
content_name: string,
content_author: string
}
```
Response: The message payload but with an added ```id:``` attribute.

#### post "/space/join"
Join a space with the invite code specified within the JSON payload. A user object with a unique id must also be included within the post body.

Request Body

```
{
invite_code:"beepbeep", 
user: {id:44, name: "Mephisto"}
}
```

Response Body

An array of messages for the given spaces


#### delete "/user/:user_id/space/:space_id"
Remove group membership from a space. HTTP 200 is returned upon successful request. There is no return body. Death is forever.


#### post "/space"




