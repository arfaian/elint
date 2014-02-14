class Role < ClassyEnum::Base
end

class Role::User < Role
end

class Role::Admin < Role
end
