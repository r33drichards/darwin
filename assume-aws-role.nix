{ pkgs ? import <nixpkgs> {} }:

let
  assumeAWSRole = pkgs.writeShellApplication {
    name = "aar";
    runtimeInputs = [ pkgs.awscli2 pkgs.jq ];
    text = ''
      # Function to assume AWS role
      assume_role() {
        local role_arn="$1"
        local session_name="$2"
        local temp_role
        local aws_access_key_id
        local aws_secret_access_key
        local aws_session_token
        local expiration

        echo "Assuming role: $role_arn"
        echo "Session name: $session_name"

        # Use AWS CLI to assume the role and capture the output
        temp_role=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name" --output json)

        # Extract the temporary credentials
        aws_access_key_id=$(echo "$temp_role" | jq -r .Credentials.AccessKeyId)
        aws_secret_access_key=$(echo "$temp_role" | jq -r .Credentials.SecretAccessKey)
        aws_session_token=$(echo "$temp_role" | jq -r .Credentials.SessionToken)
        expiration=$(echo "$temp_role" | jq -r .Credentials.Expiration)

        # Export the credentials
        export AWS_ACCESS_KEY_ID="$aws_access_key_id"
        export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
        export AWS_SESSION_TOKEN="$aws_session_token"

        echo "Temporary credentials set as environment variables."
        echo "Session expires at: $expiration"
      }

      # Check if role ARN and session name are provided as arguments
      if [ $# -ne 2 ]; then
        echo "Usage: assume-aws-role <role-arn> <session-name>" >&2
        exit 1
      fi

      ROLE_ARN="$1"
      SESSION_NAME="$2"

      # Call the function to assume the role
      assume_role "$ROLE_ARN" "$SESSION_NAME"

      echo "AWS role assumed and environment set up. You can now use AWS CLI with the assumed role."

      # Optional: Set AWS CLI profile
      # aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile assumed-role
      # aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile assumed-role
      # aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile assumed-role

      # Execute a new shell with the updated environment
      exec "$SHELL"
    '';
  };
in
  assumeAWSRole