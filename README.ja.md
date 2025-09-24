# Hotpages

__Hotpagesはアルファ版です。多数のバグがあると思いますが興味のある方は是非使ってみてください。[フィードバックはこちらまで](https://github.com/koedasha/hotpages/issues/new)__

静的サイトをRubyで書くためのRubygem

HotpagesはRubyを使った静的サイトジェネレーターのひとつです。特に手打ちでHTMLを書くようにサイトを作りながら、Rubyを使ってHTMLをDRY（Don't Repeat Yourself:コードの重複を抑えること）に保ちたい場合におすすめです。

## 特徴

- ディレクトリベースのルーティング
- RailsのActionViewに似たヘルパー関数
- ERBを第一のテンプレート言語とし、[Tilt](https://github.com/jeremyevans/tilt)により多数のテンプレートを利用可能
- [Hotwire](https://hotwired.dev)(Turbo, Stimulus)のデフォルトサポート
- ホットリロードを備えた開発用サーバで快適なWebサイトオーサリング

## インストール

Hotpagesの利用には[Ruby](https://www.ruby-lang.org/)3.4以上と[bundler](https://bundler.io)が必要です。

Rubyのインストールにrbenvを利用する場合は、[rbenvのインストール](https://github.com/rbenv/rbenv#installation)や[Rubyのインストール](https://github.com/rbenv/rbenv#installing-ruby-versions)などを参考にインストールしてください。

次のコマンドで、Rubyが正しくインストールされていることを確認してください。OKであれば次に進みます。

```bash
ruby -v # ruby 3.4以上のバージョンが表示されればOK
```

Rubyがインストールできたらbundlerをインストールします。Rubyとbundlerがインストールできたら次に進みます。

```bash
gem install bundler
```

Hotpages gemはまだレジストリに登録されていないので、下記のようにgitリポジトリをcloneしてインストールしてください。

```bash
git clone https://github.com/koedasha/hotpages.git
```

## 始めよう

リポジトリをcloneしたディレクトリで下記のコマンドを実行して、新しいHotpagesサイトを作成します。 `YOUR_NEW_SITE_NAME` は新サイトの名前に置き換えてください。

```bash
hotpages/exe/hotpages new YOUR_NEW_SITE_NAME
```

下記のコマンドにより、新しいサイトの開発用サーバーを立ち上げます。

```bash
cd YOUR_NEW_SITE_NAME
bundle install
bin/dev
```

ブラウザで `http://localhost:4000` を開き、 `Hello, hotpages!` と表示されれば成功です！

最後に静的サイトを出力してみましょう。下記のコマンドを実行します。

```bash
bin/gen
```

デフォルトでは同ディレクトリの `_site` の下に静的サイトが出力されます。

## Webページを編集する

「始めよう」につづき、エディタで `pages/index.html.erb` を開いてください。すると、ファイルには `<%= greeting %>` と書かれているはずです。`greeting` は単純なRubyのメソッドです。このメソッドは `pages/index.rb` に定義されています。

ためしに、 `pages/index.rb` の `greeting` メソッドの戻り値を変更してみましょう。すると開発サーバーのホットリロード機能により、即座にブラウザに表示されている文字列も変更されるはずです。

このように `pages` ディレクトリの下に、テンプレートファイルとそのデータを扱うためのRubyファイルを設置することによりWebページを記述するのが基本的な方法です。`pages` ディレクトリの下には自由にファイルを配置することができます。

このディレクトリ構造は、そのまま出力されるサイトのページの構造となります。

Rubyファイルの内容は、 `shared/page.rb` に記述されている `Page` クラスのサブクラスの定義となります。この `Page` クラスを変更することで全てのページに共通のメソッドを用意することなどが可能です。

### 様々なページ記述方法

#### Rubyなしのページ

テンプレートはそれのみでみWebページにコンパイルされます。特にRubyファイルが必要なければ用意する必要はありません。

#### Rubyだけのページ

Rubyファイルに `body` メソッドを定義すると、その戻り値がERBとして評価されページのHTMLにコンパイルされます。

#### ディレクトリで共通のRubyファイル

ディレクトリの中で共通のRubyファイルを用いたいときは、そのディレクトリに `_page.rb` を設置します。するとその内容がそのディレクトリの全てのテンプレートに適用されます。

### `pages` 以下の無視されるファイル

`pages` 以下に設置された、 `_` （アンダースコア）で始まるファイル名のファイルは無視され、Webページとしてコンパイルされません。

### パスの展開

`:slug.html.erb` のようにコロンで始まる名前のディレクトリやページファイルは展開されるパスとして処理されます。展開される名称には同ディレクトリの `:slug.rb` のような拡張子以外が同名のRubyファイルに定義された `self.segment_names` メソッドの戻り値が利用されます。例えば `:slug.rb` の `self.segment_names` メソッドが `[ "one", "two" ]` のような配列を返す場合、`:slug.html.erb` からは、 `one.html` と `two.html` の二つのHTMLが生成されます。

この際、ページの展開名称である `one` や `two` といった文字列は、ページファイル中で `segments` ハッシュに格納されています。ページ名が `:slug.html.erb` である場合は、`segments[:slug]` として取得できます。

## パーシャルレンダリング

`render "shared/post", post: post` のように `render` メソッドを用いてパーシャルにローカル変数を渡しながらレンダリングできます。`pages` ディレクトリの配下にパーシャルを設置し、ページファイルの中から相対パスでパーシャルファイルを指定することもできます。このとき、パーシャルファイルの名前は `_` （アンダースコア）で始まる必要があります（「`pages` 以下の無視されるファイル」を参照）。

## 各ディレクトリの説明

- `pages`
  - 最も重要なディレクトリ。上述のページ用のファイルを配置します。
- `models`
  - モデルファイルを配置します。モデルをページRubyから呼び出すことで、MVCアプリケーションを構築するのと同様の感覚でWebページを記述できます。
- `data`
  - モデルから利用するためのデータファイルを配置します。CSVやマークダウンなどを配置することを想定しています。
- `helpers`
  - ページから呼び出すことのできるヘルパーモジュールを配置します。ヘルパー関数はページ中でグローバルスコープです。
- `layouts`
  - レイアウトファイルを配置します。ページRubyで `layout "レイアウトファイル名"` とすることで用いるレイアウトファイルを変更できます。デフォルトのレイアウトファイルは `site.html.erb` です。
- `shared`
  - ページ間で共有するRubyファイルやパーシャルファイルを配置します。
- `assets`
  - JavaScript, CSS, 画像を配置します。デフォルトでは `controllers` にStimulusコントローラーのJS、`css` にCSS、imagesに `images` を配置します。
- `locales`
  - i18nのためのロケールファイルです。デフォルトでは、[FastGettext](https://github.com/grosser/fast_gettext)のyaml形式のロケールファイルを用いてローカライズが行われます。

## ERB以外のテンプレートについて

HotpagesではERBを標準でサポートしていますが、Tiltでサポートされるフォーマットであれば利用可能なはずです。Tiltでサポートされているテンプレートエンジンについては[こちらを参照](https://github.com/jeremyevans/tilt#tilt)。Hotpagesで用いるには必要なライブラリをインストールして、`site.rb` で `require` してください。例えばMarkdownのレンダリングに[Kramdown](https://kramdown.gettalong.org)を利用するには次のようにします。

```bash
bundle add kramdown
```

```ruby
# site.rb
require "kramdown"
```

こうすることで `pages/index.html.md` のようなテンプレートファイルやパーシャルを扱うことが可能となります（テンプレートファイルの拡張子の最上位はコンパイル先のファイルフォーマットを表す必要があります）。

Tiltでサポートされるテンプレートファイルは多いため全てテストできていません。もし利用中のテンプレートで不具合があれば[フィードバック](https://github.com/koedasha/hotpages/issues/new)をお願いします。

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/planeska/gem_template. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/planeska/gem_template/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [Zero-Clause BSD](https://opensource.org/license/0bsd).

## Code of Conduct

Everyone interacting in the GemTemplate project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/planeska/gem_template/blob/main/CODE_OF_CONDUCT.md).
