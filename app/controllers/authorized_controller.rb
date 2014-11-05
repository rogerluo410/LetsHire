class AuthorizedController < AuthenticatedController
  load_and_authorize_resource
end
