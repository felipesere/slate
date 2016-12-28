defmodule Slate.Admin.Security do
  defmacro __using__(_opts) do
    quote do
      plug :put_secret_key_base
      def put_secret_key_base(conn, _) do
        put_in conn.secret_key_base, "2iSeS9fRD2JNnoIEWx5OvlGD1KNi5BUsdgB18CluqCnvCscIVvBh2LfEJyfWYtfs"
      end

      if Mix.env == :prod do
        plug Slate.Admin.ProtectedHost, host: "slate-blog.herokuapp.com", scheme: "https"
      end

      if Mix.env != :test do
        plug Plug.Session, store: :cookie, key: "_hello_phoenix_key", signing_salt: "Jk7pxAMf"

        plug Slate.Admin.Authentication, exclude: ["/admin/login"]
      end
    end
  end
end
