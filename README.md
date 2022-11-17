# BMS

## Local Development Setup

### Backend

Using a terminal, change directories to backendAPI:

`cd backendAPI`

Then run the following command:

`flask --app api run --host=0.0.0.0`

You should see the following message in the console:

```
* Serving Flask app 'api'
* Debug mode: off
  WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
* Running on all addresses (0.0.0.0)
* Running on http://127.0.0.1:5000
* Running on http://10.110.135.154:5000
  Press CTRL+C to quit
```

The most important aspect of this is the last line:

`Running on http://10.110.135.154:5000`

This is the port being exposed by your laptop to the world when running this server.
It will almost certainly be different from this exact string.

To enable backend connections while using the app, go to the 
apiMiddleware in the swift code and change the urlBase constant to whatever url 
and port is provided to you

### Frontend

Using XCode, go into the project info section by clicking the blue app store icon labeled
`BLEDemo`

Change the `Bundle Identifier` to any unique identifier you want to use

Change the `iOS version` in the `Deployment Info` section to match your targeted deployment iOS 
version

In `Signing and Capabilities` be sure that the `Team` is set to your personal team or another 
team that will allow the app to build

Connect your iPhone to your Mac via USB or USB-C and select your phone from the 
dropdown at the top center of the screen. You should then be able to hit the play button and
build the app

## Backend API Data Format

Data will be sent from the frontend to the backend in the following format (after parsing):

```json
{
  "totalVoltage": [
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    },
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    }
  ],
  "voltageOne": [
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    },
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    }
  ],
  "voltageTwo": [
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    },
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    }
  ],
  "current": [
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    },
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    }
  ],
  "temperature": [
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    },
    {
      "value": "10.5",
      "timestamp": "datetime format TBD"
    }
  ]
}
```

Data will be sent from the backend to the database in the following format: <br />
float: "xxx.xx" / "5555.55" <br />
datetime: "yyyymmddss" / "2022081743" <br />
string: "xxxxxx" / "banana" <br />
